//
// Created by tonegas on 16/11/18.
//
#define LM_NNNN
#include "lightmat.h"
#include "mathcode_log.h"

int MyLogPrint(const RWCString &f)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	std::string file_name(f.getdata(),f.length);
	logger.write_line(file_name);
	return 0;
#else
	return 1;
#endif
}


int MyLogD(const RWCString &f, const RWCString &s, const double &d)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	return MyLog(f, s, d);
#else
	return 1;
#endif

}

int MyLogDN(const RWCString &f, const RWCString &s, const doubleN &d)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	return MyLog(f, s, d);
#else
	return 1;
#endif
}

int MyLogDNN(const RWCString &f, const RWCString &s, const doubleNN &d)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	return MyLog(f, s, d);
#else
	return 1;
#endif
}

int MyLogDNNN(const RWCString &f, const RWCString &s, const doubleNNN &d)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	return MyLog(f, s, d);
#else
	return 1;
#endif
}

int MyLogI(const RWCString &f, const RWCString &s, const int &d)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	return MyLog(f, s, d);
#else
	return 1;
#endif
}

int MyLogIN(const RWCString &f, const RWCString &s, const intN &d)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	return MyLog(f, s, d);
#else
	return 1;
#endif
}

int MyLogINN(const RWCString &f, const RWCString &s, const intNN &d)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	return MyLog(f, s, d);
#else
	return 1;
#endif
}

int MyLogINNN(const RWCString &f, const RWCString &s, const intNNN &d)
{
#if defined(LOG_INTERNAL) && !defined(MATHCODE)
	return MyLog(f, s, d);
#else
	return 1;
#endif
}