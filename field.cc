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

    value = new char [width];
    memset(value, 0, width);
}

Field::~Field(void) {
    if (value)
        delete[] value;

    /*
     * No need to OCIHandleFree the ``ocidefine''; according to Oracle
     * 8i, 9i, and 10g documentation OCI_HTYPE_DEFINE is not a valid
     * input into OCIHandleFree and thus the implication is that it
     * is not needed.
     */
}

Field::operator char(void) {
    return value[0];
}

Field::operator char *(void) {
    return value;
}

Field::operator const char *(void) {
    return value;
}

Field::operator int(void) {
    return strtol(value, NULL, 10);
}

Field::operator unsigned(void) {
    return strtoul(value, NULL, 10);
}

Field::operator long(void) {
    return strtol(value, NULL, 10);
}

Field::operator unsigned long(void) {
    return strtoul(value, NULL, 10);
}


