#import "BinaryHelper.h"
#include <fstream>
#include <cassert>

/* FileReader class: */

FileReader::FileReader(std::string path)
{
	this->path = path;
	f = fopen(path.c_str(), "r");
	assert(f);
}

uint32_t FileReader::read32(void)
{
	uint32_t ret = 0;
	fread((void*)&ret, sizeof(ret), 1, f);
	//file is big endian - we are little endian
	//must convert to host endianness
	return CFSwapInt32BigToHost(ret);
}

uint8_t FileReader::read8(void)
{
	uint8_t ret = 0;
	fread((void*)&ret, sizeof(ret), 1, f);
	return ret;
}

FileReader::~FileReader()
{
	fclose(f);
}

//TODO: move towards binary formatted weights file

std::vector<Eigen::MatrixXf> loadWeights(std::string filePath)
{
	std::vector<Eigen::MatrixXf> ret;

	std::ifstream f(filePath);
	std::string line;
	while (std::getline(f, line))
	{
		unsigned rows;
		unsigned cols;
		Eigen::MatrixXf w;

		std::istringstream iss(line);
		float a;
		for (int i = 0; (iss >> a); i++)
		{
			if (i == 0)
			{
				rows = a;
			}
			else if (i == 1)
			{
				cols = a;
				w.resize(rows, cols);
			}
			else
				w.data()[i - 2] = a;
			char c;
			iss >> c;
			if (c != ',') break;
		}

		ret.push_back(w);
	}

	f.close();
	return ret;
}

/*
MINST Database File Formats: 

LABEL FILE (train-labels-idx1-ubyte):
[offset] [type]          [value]          [description]
0000     32 bit integer  0x00000801(2049) magic number (MSB first)
0004     32 bit integer  60000            number of items
0008     unsigned byte   ??               label
0009     unsigned byte   ??               label
........
xxxx     unsigned byte   ??               label
The labels values are 0 to 9.

IMAGE FILE (train-images-idx3-ubyte):
[offset] [type]          [value]          [description]
0000     32 bit integer  0x00000803(2051) magic number
0004     32 bit integer  60000            number of images
0008     32 bit integer  28               number of rows
0012     32 bit integer  28               number of columns
0016     unsigned byte   ??               pixel
0017     unsigned byte   ??               pixel
........
xxxx     unsigned byte   ??               pixel
Pixels are organized row-wise. Pixel values are 0 to 255. 0 means background (white), 255 means foreground (black).
*/

std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> loadDataset(std::string dir, MNISTDatasetType type, uint32_t maxSize)
{
	std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> ret;

	//label file:
	std::string labelPath = dir + (type == MNISTDatasetTypeTest ? "t10k-labels.idx1-ubyte" : "train-labels.idx1-ubyte");
	FileReader lblFile(labelPath);
	uint32_t lblMagic = lblFile.read32();
	assert(lblMagic == 0x00000801);

	//images file:
	std::string imgPath = dir + (type == MNISTDatasetTypeTest ? "t10k-images.idx3-ubyte" : "train-images.idx3-ubyte");
	FileReader imgFile(imgPath);
	uint32_t imgMagic = imgFile.read32();
	assert(imgMagic == 0x00000803);

	uint32_t count = lblFile.read32();
	assert(count == imgFile.read32());
	size_t imgSize = imgFile.read32() * imgFile.read32();
	count = MIN(count, maxSize);

	for (uint32_t i = 0; i < count; i++)
	{
		Eigen::VectorXf x = Eigen::VectorXf::Zero(imgSize);
		for (uint32_t pi = 0; pi < imgSize; pi++)
			x[pi] = (float)imgFile.read8();
		
		Eigen::VectorXf y = Eigen::VectorXf::Zero(10);
		uint8_t label = lblFile.read8();
		y[label] = 1.f;

		ret.push_back(std::make_pair(x, y));
	}

	return ret;
}
