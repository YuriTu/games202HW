# Install script for directory: D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/nori")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/workspace/games202HW/hw2/prt/build/ext_build/openexr/OpenEXR/IlmImf/Debug/IlmImf.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/workspace/games202HW/hw2/prt/build/ext_build/openexr/OpenEXR/IlmImf/Release/IlmImf.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/workspace/games202HW/hw2/prt/build/ext_build/openexr/OpenEXR/IlmImf/MinSizeRel/IlmImf.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/workspace/games202HW/hw2/prt/build/ext_build/openexr/OpenEXR/IlmImf/RelWithDebInfo/IlmImf.lib")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/OpenEXR" TYPE FILE FILES
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfForward.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfExport.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfBoxAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCRgbaFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChannelList.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChannelListAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompressionAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDoubleAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFloatAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFrameBuffer.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfHeader.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfIO.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfIntAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLineOrderAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMatrixAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOpaqueAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOutputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgbaFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStringAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfVecAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfHuf.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfWav.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLut.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfArray.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompression.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfLineOrder.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfName.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPixelType.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfVersion.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfXdr.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfConvert.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPreviewImage.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPreviewImageAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChromaticities.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfChromaticitiesAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfKeyCode.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfKeyCodeAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTimeCode.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTimeCodeAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRational.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRationalAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFramesPerSecond.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStandardAttributes.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfEnvmap.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfEnvmapAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInt64.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgba.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTileDescription.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTileDescriptionAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledInputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledOutputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledRgbaFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfRgbaYca.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTestFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfThreading.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfB44Compressor.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfStringVectorAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiView.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfAcesFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiPartOutputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfGenericOutputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMultiPartInputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfGenericInputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPartType.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfPartHelper.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfOutputPart.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledOutputPart.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfInputPart.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfTiledInputPart.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineOutputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineOutputPart.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineInputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepScanLineInputPart.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledInputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledInputPart.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledOutputFile.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepTiledOutputPart.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepFrameBuffer.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepCompositing.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfCompositeDeepScanLine.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfNamespace.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfMisc.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepImageState.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfDeepImageStateAttribute.h"
    "D:/workspace/games202HW/hw2/prt/ext/openexr/OpenEXR/IlmImf/ImfFloatVectorAttribute.h"
    )
endif()

