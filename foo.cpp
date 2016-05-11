#include <assert.h>
#include <stdio.h>

#include <stdexcept>
#include <string>

extern "C" int add(int a, int b)
{
  return a + b;
}

// Put a class in an anonymous namespace
namespace {
  class Person {
  public:
    Person(const std::string& name_,
           const int age_):
      name(name_),
      age(age_)
    {
    }

    int days_lived() const
    {
      return age*365.254;
    }

    const std::string name;
    const int age;
  };
}

extern "C" void* new_person(const char* name, const int age)
{
  assert(name != NULL);
  Person* p = new Person(name, age);
  printf("  new Person(\"%s\", %d) at %p\n", name, age, p);
  return reinterpret_cast<void*>(p);
}

extern "C" void delete_person(Person* p)
{
  printf("  delete Person at %p\n", p);
  delete p;
}

extern "C" int days_lived(const Person* p)
{
  assert(p != NULL);
  return p->days_lived();
}

extern "C" int age(const Person* p)
{
  printf("  age(Person at %p)\n", p);
  assert(p != NULL);
  return p->age;
}

extern "C" char* name(const Person* p)
{
  printf("  name(Person at %p)\n", p);
  assert(p != NULL);
  return strdup(p->name.c_str());
}

extern "C" void foo_free(void* p)
{
  printf("  foo_free(%p)\n", p);
  assert(p != NULL);
  free(p);
}
