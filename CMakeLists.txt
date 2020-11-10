cmake_minimum_required(VERSION 3.5.0)
project(test_asyik VERSION 0.1.0)
set(CMAKE_CXX_STANDARD 17)

# include(CTest)
# enable_testing()

add_executable(${PROJECT_NAME} src/hello_libasyik.cpp)

# set(CPACK_PROJECT_NAME ${PROJECT_NAME})
# set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
# include(CPack)

find_package(libasyik REQUIRED)
if(libasyik_FOUND)
    target_include_directories(${PROJECT_NAME} PUBLIC ${libasyik_INCLUDE_DIR})
    target_link_libraries(${PROJECT_NAME} libasyik)
endif()

find_package(Boost COMPONENTS context fiber date_time REQUIRED)
if(Boost_FOUND)
    target_include_directories(${PROJECT_NAME} PUBLIC ${Boost_INCLUDE_DIR})
    target_link_libraries(${PROJECT_NAME} Boost::fiber Boost::context)
endif()


find_package(SOCI REQUIRED)
if(SOCI_FOUND)
    target_include_directories(${PROJECT_NAME} PUBLIC /usr/include/postgresql)
    target_include_directories(${PROJECT_NAME} PUBLIC /usr/local/include/soci)
    target_include_directories(${PROJECT_NAME} PUBLIC /usr/local/include/soci/postgresql)
    target_include_directories(${PROJECT_NAME} PUBLIC /usr/local/include/soci/sqlite3)
    target_link_libraries(${PROJECT_NAME} SOCI::soci_core SOCI::soci_postgresql SOCI::soci_sqlite3)
endif()

find_package(Threads REQUIRED)
target_link_libraries(${PROJECT_NAME} Threads::Threads)

find_package(OpenSSL REQUIRED)
target_link_libraries(${PROJECT_NAME} OpenSSL::SSL)
