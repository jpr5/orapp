/*
 * $Id$
 */

extern "C" {
#include <oci.h>
}

#include "constants.hh"
#include "log.hh"
#include "field.hh"


using namespace ORAPP;


Field::Field(const char n[], unsigned l, unsigned w, signed &errno_) : _errno(errno_) {
    ocidefine = NULL;

    name.assign(n, l);
    width = w;

    value = (void*)new char [width];
    memset(value, 0, width);
}

Field::~Field(void) {
    if (value)
        delete[] (char*)value;

    /*
     * No need to OCIHandleFree the ``ocidefine''; according to Oracle
     * 8i, 9i, and 10g documentation OCI_HTYPE_DEFINE is not a valid
     * input into OCIHandleFree and thus the implication is that it
     * is not needed.
     */
}

Field::operator char(void) {
    return ((char*)value)[0];
}

Field::operator char *(void) {
    return (char*)value;
}

Field::operator const char *(void) {
    return (const char *)value;
}

Field::operator int(void) {
    return strtol((char*)value, NULL, 10);
}

Field::operator unsigned(void) {
    return strtoul((char*)value, NULL, 10);
}

Field::operator long(void) {
    return strtol((char*)value, NULL, 10);
}

Field::operator unsigned long(void) {
    return strtoul((char*)value, NULL, 10);
}


