// vim: ts=4:sw=4:expandtab:
/*
 * Copyright (c) 2013 Travis Geiselbrecht
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#pragma once

#include <boost/utility.hpp>

#include <string>
#include <stdint.h>
#include <sys/types.h>

// top level object, representing the entire emulated system
class System : boost::noncopyable {
public:
    System(const std::string &subSystem);
    virtual ~System();

    virtual int Init() = 0;
    virtual int Run() = 0;

    virtual int SetRom(const std::string &rom) = 0;
    virtual int SetCpu(const std::string &cpu) = 0;

    virtual uint8_t  MemRead8(size_t address) = 0;
    virtual void     MemWrite8(size_t address, uint8_t val) = 0;
    virtual uint16_t MemRead16(size_t address) = 0;
    virtual void     MemWrite16(size_t address, uint16_t val) = 0;

    static System *Factory(const std::string &system);

protected:
    std::string mSubSystemString;
};

