#include <stdlib.h>
#include <stdio.h>
#include "vector.h"

struct vector_t {
    size_t size;
    int *data;
};

static void allocation_failed() {
    fprintf(stderr, "Out of memory.\n");
    exit(1);
}

vector_t *vector_new() {
    vector_t *retval = malloc(sizeof(vector_t));
    if (retval == NULL) {
        allocation_failed();
    }

    retval->size = 1;
    retval->data = calloc(retval->size, sizeof(int)); // Initialize data with zeros
    if (retval->data == NULL) {
        free(retval);
        allocation_failed();
    }

    return retval;
}

int vector_get(vector_t *v, size_t loc) {
    if (v == NULL) {
        fprintf(stderr, "vector_get: passed a NULL vector.\n");
        exit(1);
    }

    if (loc >= v->size) {
        return 0;
    } else {
        return v->data[loc];
    }
}

void vector_delete(vector_t *v) {
    if (v == NULL) {
        return; // Nothing to delete
    }
    free(v->data);
    free(v);
}

void vector_set(vector_t *v, size_t loc, int value) {
    if (v == NULL) {
        fprintf(stderr, "vector_set: passed a NULL vector.\n");
        exit(1);
    }

    if (loc >= v->size) {
        size_t new_size = loc + 1;
        int *new_data = realloc(v->data, new_size * sizeof(int));
        if (new_data == NULL) {
            allocation_failed();
        }
        v->size = new_size;
        v->data = new_data;

        // Initialize newly allocated memory with zeros
        for (size_t i = v->size - 1; i > loc; i--) {
            v->data[i] = 0;
        }
    }

    v->data[loc] = value;
}

