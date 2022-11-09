#include "denoiser.h"

Denoiser::Denoiser() : m_useTemportal(false) {}

void Denoiser::Reprojection(const FrameInfo &frameInfo) {
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    Matrix4x4 preWorldToScreen =
        m_preFrameInfo.m_matrix[m_preFrameInfo.m_matrix.size() - 1];
    Matrix4x4 preWorldToCamera =
        m_preFrameInfo.m_matrix[m_preFrameInfo.m_matrix.size() - 2];
#pragma omp parallel for
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Reproject
            m_valid(x, y) = false;
            m_misc(x, y) = Float3(0.f);
        }
    }
    std::swap(m_misc, m_accColor);
}

void Denoiser::TemporalAccumulation(const Buffer2D<Float3> &curFilteredColor) {
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    int kernelRadius = 3;
#pragma omp parallel for
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Temporal clamp
            Float3 color = m_accColor(x, y);
            // TODO: Exponential moving average
            float alpha = 1.0f;
            m_misc(x, y) = Lerp(color, curFilteredColor(x, y), alpha);
        }
    }
    std::swap(m_misc, m_accColor);
}

Buffer2D<Float3> Denoiser::Filter(const FrameInfo &frameInfo) {
    int height = frameInfo.m_beauty.m_height;
    int width = frameInfo.m_beauty.m_width;
    Buffer2D<Float3> filteredImage = CreateBuffer2D<Float3>(width, height);
    int kernelRadius = 16;
#pragma omp parallel for
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Joint bilateral filter
            // std::exp
            float sum_of_weight = 0.0f;
            Float3 sum_of_weight_value;
            // 当前点i
            Float3 i = frameInfo.m_beauty(x, y);
            int j_min_x = std::max(0, x - kernelRadius);
            int j_max_x = std::min(width, x + kernelRadius);
            int j_min_y = std::max(0, y - height);
            int j_max_y = std::min(height, y + kernelRadius);
            Float3 i_normal = frameInfo.m_normal(x,y);
            Float3 i_position = frameInfo.m_position(x,y);
            

            // 关系点j
            for (int j_x = j_min_x; j_x < j_max_x; j_x++) {
                for (int j_y = j_min_y; j_y < j_max_y; j_y++) {
                    
                    Float3 j = frameInfo.m_beauty(j_x,j_y);
                    Float3 i_xy = Float3(x,y,0.0f);
                    Float3 j_xy = Float3(j_x,j_y,0.0f);
                    Float3 j_normal = frameInfo.m_normal(j_x,j_y);
                    Float3 j_position = frameInfo.m_position(j_x,j_y);

                    float kernel = 1.0f;

                    float distance = Sqr(Length(i_xy - j_xy)) / (2.0f * std::pow(m_sigmaCoord, 2.0f)) * -1.0f;
                    float color = Sqr(Length(i - j)) /  (2.0f * std::pow(m_sigmaColor, 2.0f)) * -1.0f;
                    float normal_ij = std::acos( Dot(Normalize(i), Normalize(j)) );
                    float normal = std::pow(Sqr(normal_ij), 2.0f) / (2 * std::pow(m_sigmaNormal, 2.0f)) * -1.0f;
                    float plane_ij = Dot(i_normal, Normalize(j_position - i_position) );
                    float plane = std::pow(plane_ij, 2.0f) / (2.0f * std::pow(m_sigmaPlane, 2.0f)) * -1.0f;

                    float weight = std::exp(distance + color + normal + plane);
                    sum_of_weight += weight; 
                    sum_of_weight_value += (j * weight);
                }
            }

            // 结果
            filteredImage(x, y) = sum_of_weight_value / sum_of_weight;
        }
    }
    return filteredImage;
}

void Denoiser::Init(const FrameInfo &frameInfo, const Buffer2D<Float3> &filteredColor) {
    m_accColor.Copy(filteredColor);
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    m_misc = CreateBuffer2D<Float3>(width, height);
    m_valid = CreateBuffer2D<bool>(width, height);
}

void Denoiser::Maintain(const FrameInfo &frameInfo) { m_preFrameInfo = frameInfo; }

Buffer2D<Float3> Denoiser::ProcessFrame(const FrameInfo &frameInfo) {
    // Filter current frame
    Buffer2D<Float3> filteredColor;
    filteredColor = Filter(frameInfo);

    // Reproject previous frame color to current
    if (m_useTemportal) {
        Reprojection(frameInfo);
        TemporalAccumulation(filteredColor);
    } else {
        Init(frameInfo, filteredColor);
    }

    // Maintain
    Maintain(frameInfo);
    if (!m_useTemportal) {
        m_useTemportal = true;
    }
    return m_accColor;
}
