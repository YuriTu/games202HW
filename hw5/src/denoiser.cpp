#include "denoiser.h"
#include <algorithm>


Denoiser::Denoiser() : m_useTemportal(false) {}

// 找上一帧的对应像素 frameInfo当前帧信息  Denoiser::m_accColor 上一帧结果 m_valid 是否合法
// screen = PVM()
void Denoiser::Reprojection(const FrameInfo &frameInfo) {
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    Matrix4x4 preWorldToScreen =
        m_preFrameInfo.m_matrix[m_preFrameInfo.m_matrix.size() - 1];
    Matrix4x4 preWorldToCamera =
        m_preFrameInfo.m_matrix[m_preFrameInfo.m_matrix.size() - 2];
        std::cout << " preject 1" << std::endl;
#pragma omp parallel for 
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Reproject
            m_valid(x, y) = false;
            m_misc(x, y) =  Float3(0.f);
            // 0. 当前像素 屏幕坐标
            // x y
            // 1. 当前帧的世界坐标
            Float3 position = frameInfo.m_position(x,y);
            
            // 2. 世界坐标到物体坐标
            //对应的物体标号
            float item_id = frameInfo.m_id(x,y);
            if (item_id == -1) {
                continue;
            }
            // 物体到世界
            Matrix4x4 item_matrix = frameInfo.m_matrix[item_id];
            // fixme
            // std::cout << " preject 1.1, id :" << item_id << std::endl;
            auto world2module = Inverse(item_matrix);
            // std::cout << " preject 2" << std::endl;
            // 上一帧
            // 3.物体到世界
            auto pre_module2world = m_preFrameInfo.m_matrix[item_id];
            // 4. 世界到camera => 屏幕
            auto pre_world2screen = preWorldToScreen;

            Float3 pre_item_screen_position = pre_world2screen(
                pre_module2world(
                    world2module(
                            position, Float3::Point
                        ),Float3::Point
                ),
                Float3::Point
            );
            bool inScreen = 
                pre_item_screen_position.x <0 || pre_item_screen_position.x > width ||
                pre_item_screen_position.y <0 || pre_item_screen_position.y > height;
            // std::cout << " preject 3" << std::endl;
            // 目前像素对应的物体标号
            float pre_item_id = m_preFrameInfo.m_id(pre_item_screen_position.x, pre_item_screen_position.y);

            bool isSameObject = pre_item_id == item_id;

            // 2. 判断是否合法
            // 1. 对应的xy在不在屏幕
            // 2.  m_id是否能对上
            // std::cout << " preject 4" << std::endl;
            if (inScreen && isSameObject) {
                m_valid(x,y) = true;
                // 把上一帧的投影结果 保存下来，表示使用，在当前帧后面渲染会参考使用
                m_misc(x, y) = m_accColor(pre_item_screen_position.x, pre_item_screen_position.y);
            }
            
        }
    }
    std::swap(m_misc, m_accColor);
}
// 当前帧 curFilteredColor的滤波后结果
void Denoiser::TemporalAccumulation(const Buffer2D<Float3> &curFilteredColor) {
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    int kernelRadius = 3;
#pragma omp parallel for
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Temporal clamp
            // acc是上一帧的投影后参考结果
            Float3 prevFrameColor = m_accColor(x, y);
            Float3 currentFrameColor = curFilteredColor(x, y);
            // 指数均线
            // TODO: Exponential moving average
            float alpha = 1.0f;
            if (m_valid(x,y)) {
                alpha = 0.25;
                float k = 1.0f;
                // int kernelRadius = 7;
                int j_min_x = std::max(0, x - kernelRadius);
                int j_max_x = std::min(width, x + kernelRadius);
                int j_min_y = std::max(0, y - height);
                int j_max_y = std::min(height, y + kernelRadius);

                std::vector<Float3> list;
                Float3 amount;
                float count;
                Float3 variance;

                for (int j_x = j_min_x; j_x < j_max_x; j_x++ ) {
                    for (int j_y = j_min_y; j_y < j_max_y; j_y++) {
                        Float3 temp = curFilteredColor(j_x,j_y);
                        list.push_back(temp);
                        amount += temp;
                        count += 1.0f;
                    }
                }
                // mean
                Float3 avg = amount / count;
                // var
                std::for_each(std::begin(list),std::end(list), [&](const Float3 i) {
                    variance += ( (i - avg) * (i - avg) );
                });
                variance /= count;

                prevFrameColor = Clamp(prevFrameColor,avg - variance * k , avg + variance * k);

            };
            // curfile 当前帧
            m_misc(x, y) = Lerp(prevFrameColor, currentFrameColor , alpha);
        }
    }
    std::swap(m_misc, m_accColor);
}

Buffer2D<Float3> Denoiser::Filter(const FrameInfo &frameInfo) {
    int height = frameInfo.m_beauty.m_height;
    int width = frameInfo.m_beauty.m_width;
    Buffer2D<Float3> filteredImage = CreateBuffer2D<Float3>(width, height);
    int kernelRadius = 16;
    std::cout << " filter 1" << std::endl;
#pragma omp parallel for
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            // TODO: Joint bilateral filter
            // std::exp
            float sum_of_weight = 0.0f;
            Float3 sum_of_weight_value;
            // 当前点i
            Float3 i = frameInfo.m_beauty(x, y);
            Float3 i_xy = Float3(x,y,0.0f);
            Float3 i_normal = frameInfo.m_normal(x,y);
            Float3 i_position = frameInfo.m_position(x,y);
            
            int j_min_x = std::max(0, x - kernelRadius);
            int j_max_x = std::min(width, x + kernelRadius);
            int j_min_y = std::max(0, y - height);
            int j_max_y = std::min(height, y + kernelRadius);
            // 关系点j
            for (int j_x = j_min_x; j_x < j_max_x; j_x++) {
                for (int j_y = j_min_y; j_y < j_max_y; j_y++) {
                    if (j_x == x && j_y == y) {
                        sum_of_weight += 1.0f; 
                        sum_of_weight_value += i;

                        continue;
                    }
                    
                    Float3 j = frameInfo.m_beauty(j_x,j_y);
                    Float3 j_xy = Float3(j_x,j_y,0.0f);
                    Float3 j_normal = frameInfo.m_normal(j_x,j_y);
                    Float3 j_position = frameInfo.m_position(j_x,j_y);
                    float distance = SqrDistance(i_position, j_position) / (2.0f * std::pow(m_sigmaCoord, 2.0f)) * -1.0f;
                    
                    float color = SqrDistance(i,j) /  (2.0f * std::pow(m_sigmaColor, 2.0f)) * -1.0f;
                    float normal_ij = SafeAcos( Dot(i_normal, j_normal) );
                    float normal = Sqr(normal_ij) / (2 * std::pow(m_sigmaNormal, 2.0f)) * -1.0f;
                    float plane_ij = 0.0f;
                    if (distance != 0.0f) {
                        plane_ij = Dot(i_normal, Normalize(j_position - i_position) );
                    }
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
    std::cout << " filter 4" << std::endl;
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
    std::cout << "before filter" << std::endl;
    filteredColor = Filter(frameInfo);
    std::cout << "after filter" << std::endl;

    // Reproject previous frame color to current
    if (m_useTemportal) {
        std::cout << "before reporjection" << std::endl;
        Reprojection(frameInfo);
        std::cout << "before accmulation" << std::endl;
        TemporalAccumulation(filteredColor);
    } else {
        Init(frameInfo, filteredColor);
    }
    std::cout << "done temp" << std::endl;
    
    // Maintain
    Maintain(frameInfo);
    if (!m_useTemportal) {
        m_useTemportal = true;
    }
    return m_accColor;
}
