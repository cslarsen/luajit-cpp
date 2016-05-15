#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include <string>

class Person {
public:
  Person(const std::string& name_,
         const int age_):
    name(name_),
    age(age_)
  {
  }

  const std::string name;
  const int age;
};

extern "C" void* new_person(const char* name, int age)
{
  assert(name != NULL);
  Person *p = new Person(name, age);
  return static_cast<void*>(p);
}

extern "C" void delete_person(Person* p)
{
  delete p;
}

extern "C" int age(const Person* p)
{
  assert(p != NULL);
  return p->age;
}

static char* local_strdup(const char* in)
{
  assert(in != NULL);
  char *out = static_cast<char*>(malloc(1 + strlen(in)));
  return strcpy(out, in);
}

extern "C" char* name(const Person* p)
{
  assert(p != NULL);
  return local_strdup(p->name.c_str());
}
