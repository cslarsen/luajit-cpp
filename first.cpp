#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#ifdef __cplusplus
# define EXTERNC extern "C"
#else
# define EXTERNC
#endif

EXTERNC int add(int a, int b)
{
  return a + b;
}

EXTERNC const char* now_iso8601_utc()
{
  const size_t size = 21;
  char *buffer = (char*) malloc(sizeof(char)*size);

  const time_t t = time(NULL);
  if (!strftime(buffer, size, "%FT%TZ", gmtime(&t))) {
    buffer[0] = '\0';
  }

  return buffer;
}

EXTERNC const char* random_quote()
{
  static const char* quotes[] = {
    "Lisp isn't a language, it's a building material.\n"
    "-Alan Kay",

    "Debugging is twice as hard as writing the code in the first place.\n"
    "Therefore, if you write the code as cleverly as possible, you are,\n"
    "by definition, not smart enough to debug it.\n"
    "- Brian W. Kernighan.",

    "A delayed game is eventually good, but a rushed game is forever bad.\n"
    "- Shigeru Miyamoto",

    "If debugging is the process of removing software bugs, then\n"
    "programming must be the process of putting them in.\n"
    "- Dijkstra",

    "In order to solve this differential equation you look at it till a\n"
    "solution occurs to you.\n"
    "- George Pólya",
  };

  const int index = arc4random() % sizeof(quotes)/sizeof(char*);
  return quotes[index];
}
