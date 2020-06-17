#import "BinaryHelper.h"
#include <fstream>

//Endianness helpers:
#define SWAP_UINT16(x) (((x) >> 8) | ((x) << 8))
#define SWAP_UINT32(x) (((x) >> 24) | (((x) & 0x00FF0000) >> 8) | (((x) & 0x0000FF00) << 8) | ((x) << 24))

/* FileReader class: */

FileReader::FileReader(std::string path)
{
	this->path = path;
	f = fopen(path.c_str(), "r");
}

uint32_t FileReader::read32(void)
{
	uint32_t ret = 0;
	fread((void*)&ret, sizeof(ret), 1, f);
	//file is big endian - we are little endian
	//must convert to host endianness
	return SWAP_UINT32(ret);
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

std::vector<uint8_t> loadLabels(std::string path)
{
	std::vector<uint8_t> labels;
	FileReader f(path);
	uint32_t magic = f.read32();
	if (magic == 0x00000801)
	{
		uint32_t itemCount = f.read32();
		for (uint32_t i = 0; i < itemCount; i++)
		{
			labels.push_back(f.read8());
		}
	}
	return labels;
}

std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> loadDataset(std::string dir, MNISTDatasetType type)
{
	std::string labelPath = dir + (type == MNISTDatasetTypeTest ? "t10k-labels.idx1-ubyte" : "train-labels.idx1-ubyte");
	std::vector<uint8_t> labels = loadLabels(labelPath);
	//DEBUG
	for (uint32_t i = 0; i < 20; i++)
		RLog(@"%u", (unsigned)labels[i]);
	return {};
}
