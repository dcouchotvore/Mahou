/************************************************************************
* Project:
* Create Date: 20 March 2012
* Originator:  Duane A. Couchot-Vore
* $Rev: 1 $
* $Date: $
*************************************************************************
*
* Function: T
*
*************************************************************************
*
* Copyright 2012 Garrett-Roe Lab, University of Pittsburgh
*
************************************************************************/

#ifndef __EXCEPTIONS_H__
#define __EXCEPTIONS_H__

#include <string>
#include <vector>
#include <exception>

namespace Mahou {

class Exception {
	public:
		Exception(const std::string &message) : m_id("Unknown exception"), m_message(message) {
			show();
        }
		Exception(const std::string &id, const std::string &message) : m_id(id), m_message(message) {
			show();
		}
		virtual std::string Why() { return m_id + ": " + m_message; }
		std::vector<std::string> &stackTrace() { return m_stackTrace; }
		int show();
	protected:
		std::string m_id, m_message;
		std::vector<std::string> m_stackTrace;
};

// Wrap STL exceptions into exceptions that cat reflect the stack trace.

class STLException : public Exception {
	STLException(std::exception E, const std::string &message) : Exception((std::string("STD Exception") + E.what()).c_str(), message) { }
};

// Math exceptions

class ExceptionMath : public Exception {
	public:
		ExceptionMath(const std::string &message) : Exception("Math exception", message) { }
		ExceptionMath(const std::string &id, const std::string &message) : Exception(id, message) { }
};

class ExceptionMathBadParameter : public ExceptionMath {
	public:
		ExceptionMathBadParameter(const std::string &message) : ExceptionMath("Math: Bad parameter", message) { }
};

class ExceptionZeroDivide : public ExceptionMath {
	public:
		ExceptionZeroDivide(const std::string &message) : ExceptionMath("Math: Divide by zero", message) { }
};

class ExceptionSingularSystem : public ExceptionMath {
	public:
		ExceptionSingularSystem(const std::string &message) : ExceptionMath("Math: Singular system", message) { }
};

class ExceptionNoConvergence : public ExceptionMath {
	public:
		ExceptionNoConvergence(const std::string &message) : ExceptionMath("Math: System does not converge", message) { }
};

class ExceptionBadDimensionality : public ExceptionMath {
	public:
		ExceptionBadDimensionality(const std::string &message) : ExceptionMath("Math: Bad dimensionality", message) { }
};

// I/O exceptions

class ExceptionIO : public Exception {
	public:
		ExceptionIO(const std::string &message) : Exception("I/O exception", message) { }
		ExceptionIO(const std::string &id, const std::string &message) : Exception(id, message) { }
};

class ExceptionNoFile : public ExceptionIO {
	public:
		ExceptionNoFile(const std::string &message) : ExceptionIO("I/O: Cannot find file", message) { }
};

class ExceptionNoDevice : public ExceptionIO {
	public:
		ExceptionNoDevice(const std::string &message) : ExceptionIO("I/O: Cannot connect to device", message) { }
};

class ExceptionCannotOpen : public ExceptionIO {
	public:
		ExceptionCannotOpen(const std::string &message) : ExceptionIO("I/O: Cannot open file", message) { }
};

class ExceptionNoPath : public ExceptionIO {
	public:
		ExceptionNoPath(const std::string &message) : ExceptionIO("I/O: Cannot find path", message) { }
};

class ExceptionNoRead : public ExceptionIO {
	public:
		ExceptionNoRead(const std::string &message) : ExceptionIO("I/O: Cannot read file", message) { }
};

class ExceptionNoWrite : public ExceptionIO {
	public:
		ExceptionNoWrite(const std::string &message) : ExceptionIO("I/O: Cannot write file", message) { }
};

class ExceptionIORights : public ExceptionIO {
	public:
		ExceptionIORights(const std::string &message) : ExceptionIO("I/O: Do not have privileges for this operation", message) { }
};

class ExceptionIOUnknown : public ExceptionIO {
	public:
		ExceptionIOUnknown(const std::string &message) : ExceptionIO("I/O: Unknown error", message) { }
};

class ExceptionSystem : public Exception {
	public:
		ExceptionSystem(const std::string &message) : Exception("System exception", message) { }
		ExceptionSystem(const std::string &id, const std::string &message) : Exception(id, message) { }
};

class ExceptionBadIndex : public ExceptionSystem {
	public:
		ExceptionBadIndex(const std::string &message) : ExceptionSystem("System: Bad index", message) { }
};

class ExceptionUnknownParameter : public ExceptionSystem {
	public:
		ExceptionUnknownParameter(const std::string &message) : ExceptionSystem("System: Unknown parameter", message) { }
};

class ExceptionDuplicateParameter : public ExceptionSystem {
	public:
		ExceptionDuplicateParameter(const std::string &message) : ExceptionSystem("System: Duplicate parameter", message) { }
};

class ExceptionParameterNameTooLong : public ExceptionSystem {
	public:
		ExceptionParameterNameTooLong(const std::string &message) : ExceptionSystem("System: Parameter name too long", message) { }
};

class ExceptionParseError : public ExceptionSystem {
	public:
		ExceptionParseError(const std::string &message) : ExceptionSystem("System: Parse error", message) { }
};

class ExceptionLoadLibrary : public ExceptionSystem {
	public:
		ExceptionLoadLibrary(const std::string &message) : ExceptionSystem("System: Cannot load libary ", message) { }
};

class ExceptionLibraryCallNotFound : public ExceptionSystem {
	public:
		ExceptionLibraryCallNotFound(const std::string &message) : ExceptionSystem("System: Library call not found ", message) { }
};

class ExceptionCallLibrary : public ExceptionSystem {
	public:
		ExceptionCallLibrary(const std::string &message) : ExceptionSystem("System: Invalid library call: ", message) { }
};

class ExceptionEnumeratedSystem : public ExceptionSystem {
	public:
		ExceptionEnumeratedSystem(const std::string &message, const int err) : ExceptionSystem("GDI exception", prepareError(message, err)) { }
		ExceptionEnumeratedSystem(const std::string &id, const std::string &message, const int err) : ExceptionSystem(id, prepareError(message, err)) { }
	private:
		std::string prepareError(const std::string &msg, const int err);
};

class ExceptionGDI : public ExceptionEnumeratedSystem {
	public:
		ExceptionGDI(const std::string &message, const int err) : ExceptionEnumeratedSystem("GDI exception", message, err) { }
		ExceptionGDI(const std::string &id, const std::string &message, const int err) : ExceptionEnumeratedSystem(id, message, err) { }
};

class ExceptionMechanical : public Exception {
	public:
		ExceptionMechanical(const std::string &message) : Exception("Mechanical exception", message) { }
		ExceptionMechanical(const std::string &id, const std::string &message) : Exception(id, message) { }
};

class ExceptionMovement : public ExceptionMechanical {
	public:
		ExceptionMovement(const std::string &message) : ExceptionMechanical("Mechanical: Movement", message) { }
};

}
#endif
