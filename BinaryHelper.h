#include <vector>
#include <Eigen/Sparse>
#include <string>
#include <utility>
#include <cstdint>
#include <cstdio>

class FileReader
{
protected:
	std::string path;
	FILE* f = NULL;

public:
	FileReader(std::string path);
	uint32_t read32(void);
	uint8_t read8(void);
	~FileReader();
};

typedef enum
{
	MNISTDatasetTypeTrain,
	MNISTDatasetTypeTest
} MNISTDatasetType;

std::vector<Eigen::MatrixXf> loadWeights(std::string filePath);
std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> loadDataset(std::string dir, MNISTDatasetType type, uint32_t maxSize = UINT32_MAX);
