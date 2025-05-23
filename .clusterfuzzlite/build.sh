#!/bin/bash -eu

autoreconf -i
./configure --disable-dependency-tracking
make -j$(nproc)

$CXX $CXXFLAGS -std=c++20 -Ilib/includes -Ilib \
     fuzz/fuzz_http3serverreq.cc -o $OUT/fuzz_http3serverreq \
     $LIB_FUZZING_ENGINE lib/.libs/libnghttp3.a

$CXX $CXXFLAGS -std=c++20 -Ilib/includes -Ilib \
     fuzz/fuzz_qpackdecoder.cc -o $OUT/fuzz_qpackdecoder \
     $LIB_FUZZING_ENGINE lib/.libs/libnghttp3.a

zip -j $OUT/fuzz_http3serverreq_seed_corpus.zip fuzz/corpus/fuzz_http3serverreq/*
zip -j $OUT/fuzz_qpackdecoder_seed_corpus.zip fuzz/corpus/fuzz_qpackdecoder/*
