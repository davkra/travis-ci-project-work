#include <iostream>

#include <add.hpp>
#include <hello.hpp>
#include <multiply.hpp>

int main(int argc, char const *argv[]) {
  hello();
  std::cout << multiply(add(2, 2), add(3, 3)) << std::endl;

  hi("TEst");

  return 0;
}
