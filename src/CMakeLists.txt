cmake_minimum_required(VERSION 3.14)
project(resizeimg)
set(CMAKE_CXX_STANDARD 17)

add_executable(${PROJECT_NAME} resize_cv.cpp)

find_package(OpenCV REQUIRED)
if(OpenCV_FOUND)
    target_include_directories(${PROJECT_NAME} PUBLIC ${OpenCV_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})
endif()