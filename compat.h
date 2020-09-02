/*
 * Copyright (c) 2020, Muli Management P/L, Wahroonga, NSW, Australia
 */

#ifdef __linux__
#define freezero(ptr, size)			\
  {						\
    if (ptr != NULL) {				\
      memset(ptr, 0, size);			\
      free(ptr);				\
    } \
  }
#endif

void *recallocarray(void *ptr, size_t oldnmemb, size_t newnmemb, size_t size);
