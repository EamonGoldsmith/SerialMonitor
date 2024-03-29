#!/bin/bash

# define toolchain (should be same on jetson)
CC := gcc
LD := gcc

# options
TARGET := mon

# define directories
SRC_DIR := ./src
BUILD_DIR := ./obj

# find files
SRC := $(shell find -wholename '$(SRC_DIR)/*.c')
OBJS := $(SRC:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

INC_DIRS := $(shell find $(SRC_DIR) -type d)
INC_FLAGS := $(addprefix -I, $(INC_DIRS))

LDFLAGS += -lc
CFLAGS += -g $(INC_FLAGS)

# default rule
all: $(shell mkdir -p ./obj) $(TARGET)

# link step
$(TARGET): $(OBJS)
	$(LD) $(OBJS) -o $@ $(LDFLAGS)

# build step
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean tests

clean:
	rm -r $(BUILD_DIR)
	rm $(TARGET)
