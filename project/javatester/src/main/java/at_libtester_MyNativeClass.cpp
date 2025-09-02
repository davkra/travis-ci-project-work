#include "at_libtester_MyNativeClass.h"
#include <stdio.h>

#include <add.hpp>
#include <hello.hpp>

JNIEXPORT void JNICALL
Java_at_libtester_MyNativeClass_myNativeMethod(JNIEnv *env, jclass cls) {
  printf("Hello from native method!\n");
}

JNIEXPORT void JNICALL Java_at_libtester_MyNativeClass_hello(JNIEnv *, jclass) {
  hello();
}

JNIEXPORT jint JNICALL Java_at_libtester_MyNativeClass_add(JNIEnv *, jclass,
                                                           jint a, jint b) {
  return add((int)a, int(b));
}

JNIEXPORT void JNICALL Java_at_libtester_MyNativeClass_hi(JNIEnv *env, jclass,
                                                          jstring str) {
  const char *c_str = env->GetStringUTFChars(str, NULL);

  if (c_str == NULL) {
    return;
  }
  std::string s(c_str);
  env->ReleaseStringUTFChars(str, c_str);

  hi(s);
}
