//
// Created by tonegas on 16/11/18.
//
#define LM_NNNN
#include "lightmat.h"

#ifdef LOG_INTERNAL
#include "logvars.h"

template<class T>
int MyLog(const RWCString &f, const RWCString &s, const T &d) {
	std::string file_name(f.getdata(),f.length);
	std::string var_name(s.getdata(),s.length);
	logger.log_var(file_name,var_name,d);
	return 0;
}

#endif

int MyLogPrint(const RWCString &f);
int MyLogD(const RWCString &f, const RWCString &s, const double &d);
int MyLogDN(const RWCString &f, const RWCString &s, const doubleN &d);
int MyLogDNN(const RWCString &f, const RWCString &s, const doubleNN &d);
int MyLogDNNN(const RWCString &f, const RWCString &s, const doubleNNN &d);
int MyLogI(const RWCString &f, const RWCString &s, const int &d);
int MyLogIN(const RWCString &f, const RWCString &s, const intN &d);
int MyLogINN(const RWCString &f, const RWCString &s, const intNN &d);
int MyLogINNN(const RWCString &f, const RWCString &s, const intNNN &d);
