// This header file should be strictly C code. The signatures will look almost
// the same as in the C++ file foo.cpp, but we'll use a fake `struct person*`
// instead of the C++ class `Person*` as return values. The signature is not
// embedded in the library file; dlsym only looks for names, so that's fine. It
// will be treated as a pointer regardless: The types only exist at compile
// time. Don't worry.

const char* name(struct person* p);
int add(int a, int b);
int age(struct person* p);
int days_lived(struct person* p);
struct person* new_person(const char* name, const int age);
void delete_person(struct person* p);
