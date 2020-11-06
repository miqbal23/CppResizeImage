#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

int main(int argc, char** argv)
{
	// Read the image file
	Mat inImg = imread("/src/img/sample.png");

	// Check for failure
	if (inImg.empty()) 
	{
		cout << "Could not open or find the image" << endl;
		return -1;
	}

	Mat dst;
	
	resize(inImg, dst, cv::Size(400,400));
	imwrite("sample_resized.jpg", dst);

	cout << "Finished resizing image" << endl;
	return 0;
}