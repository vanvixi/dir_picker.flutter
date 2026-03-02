/*
 * Dart API DL implementation.
 *
 * Implements Dart_InitializeApiDL and Dart_PostCObject_DL using the data
 * structure passed from `NativeApi.initializeApiDLData` in Dart.
 *
 * The DartApi structure layout is stable across Dart SDK 2.x:
 *   struct DartApiEntry { const char* name; void (*function)(void); }
 *   struct DartApi      { int major; int minor; const DartApiEntry* functions; }
 *
 * Only Dart_PostCObject is extracted — the only Dart VM function this plugin
 * needs to send results back via NativePort.
 */

#include "dart_api_dl.h"

#include <string.h>
#include <stdint.h>
#include <stdbool.h>

/* Mirror of the internal DartApi data layout (stable since Dart 2.0). */
typedef struct {
    const char*   name;
    void        (*function)(void);
} DartApiEntry_t;

typedef struct {
    const int              major;
    const int              minor;
    const DartApiEntry_t*  functions;
} DartApi_t;

#define DART_API_DL_MAJOR_VERSION 2

typedef bool (*PostCObject_f)(int64_t port_id, Dart_CObject* message);
static PostCObject_f s_post = NULL;

intptr_t Dart_InitializeApiDL(void* data) {
    const DartApi_t* api = (const DartApi_t*)data;
    if (api->major != DART_API_DL_MAJOR_VERSION) return -1;

    const DartApiEntry_t* e = api->functions;
    while (e->name != NULL) {
        if (strcmp(e->name, "Dart_PostCObject") == 0) {
            s_post = (PostCObject_f)(void*)e->function;
            break;
        }
        e++;
    }
    return 0;
}

bool Dart_PostCObject_DL(int64_t port_id, Dart_CObject* message) {
    if (s_post == NULL) return false;
    return s_post(port_id, message);
}
