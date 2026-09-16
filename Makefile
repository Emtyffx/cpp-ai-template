CXX := g++
C_FLAGS := -Wextra -Wall -Werror -g -MMD -MP
LDD_FLAGS :=

SRC_DIR := src
BUILD_DIR := build
TARGET := target

CXX_FILES := $(shell find $(SRC_DIR) -name "*.cpp")
O_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(CXX_FILES))
DEPS := $(patsubst %.o,%.d,$(O_FILES))

GET_CFLAGS = $(shell pkg-config --cflags $(1) | sed 's/-I/-isystem /g')

EIGEN_CFLAGS := $(call GET_CFLAGS,eigen3)
EIGEN_LDDFLAGS := $(shell pkg-config --libs eigen3)

C_FLAGS += $(EIGEN_CFLAGS)
LDD_FLAGS += $(EIGEN_LDDFLAGS)


all: $(BUILD_DIR)/$(TARGET)

-include $(DEPS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(C_FLAGS) -c $< -o $@

$(BUILD_DIR):
	@mkdir $@

$(BUILD_DIR)/$(TARGET): $(O_FILES)
	$(CXX) $(LDD_FLAGS) $^ -o $@

clean:
	rm -rf $(BUILD_DIR)

compile_flags.txt:
	@echo $(C_FLAGS) | tr " " "\n" > $@
	

.PHONY: all clean


