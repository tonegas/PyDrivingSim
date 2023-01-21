#include <vector>
#include <fstream>
#include <mutex>
#include <string>
#include <map>
#include <vector>
#include <algorithm>
#include <thread>
#include <sstream>
#include <sys/stat.h>
#include <iostream>

#if defined(_WIN32)
#include <direct.h>
#endif

#ifndef ANYBASE_CLASS_LOG
#define ANYBASE_CLASS_LOG

class AnyBase
{
public:
	virtual ~AnyBase() = 0;
	virtual void print(std::ostream& out) const = 0;
	friend std::ostream& operator<< (std::ostream& out, const AnyBase& mc) {
		mc.print(out);
		return out;
	}
};
inline AnyBase::~AnyBase() {}

template<class T>
class Any : public AnyBase
{
public:
	typedef T Type;
	explicit Any(const Type& data) : data(data) {}
	Any() {}
	Type data;
	virtual void print(std::ostream& out) const {
		out << data;
	}
};

typedef std::vector<std::unique_ptr<AnyBase> > VarVal;
typedef std::vector<std::string> VarName;
typedef std::map<std::string,int> VarIdx;

class LogManager {
	bool enabled;
	std::string log_foder;
	std::map<std::string, bool> disabled_log;
	std::map<std::string, bool> list_first_print;
	std::map<std::string, std::unique_ptr<std::ofstream>> list_file;
public:
	std::map<std::string, VarIdx> list_var_idx;
	std::map<std::string, VarVal> list_var_value;
	std::map<std::string, VarName> list_var_name;

	LogManager() {
		enabled = false;
	}
	~LogManager(){
		if(enabled) {
			for (std::map<std::string, std::unique_ptr<std::ofstream>>::iterator it = list_file.begin();
			     it != list_file.end(); ++it) {
				it->second->close();
			}
		}
	}

	void enable(bool aux, std::string folder = "log_internal"){
#ifdef DEBUG
		std::cout << "Logger: Create log file in folder " << folder << std::endl;
#endif
		enabled = aux;
		if(enabled){
			log_foder = folder;
			// Create log directory if it doesn't exist
			struct stat st = { 0 };
			if (stat(log_foder.c_str(), &st) == -1) {
#ifdef _WIN32
                _mkdir(log_foder.c_str());
#else
                mkdir(log_foder.c_str(), S_IRWXU | S_IRWXG);
#endif
			}
		}
	}


	void disable_log(std::string file){
#ifdef DEBUG
		std::cout << "Logger: Remove log file " << file << std::endl;
#endif
		disabled_log[file] = true;
	}

	bool is_enabled(std::string file) {
		return (enabled && (disabled_log.find(file) == disabled_log.end() ||
		        (disabled_log.find(file) != disabled_log.end() && !disabled_log[file])) &&
		        list_file.find(file) != list_file.end());
	}

	void enable_log(std::string file){
#ifdef DEBUG
		std::cout << "Logger: Remove log file " << file << std::endl;
#endif
		disabled_log[file] = false;
	}

	template<class K>
	void log_var(std::string file, std::string varname, K var){
#ifdef DEBUG
		std::cout << "Logger "<< file << ": Append variable " << varname << std::endl;
#endif

		if(enabled && (disabled_log.find(file) == disabled_log.end() ||
		               (disabled_log.find(file) != disabled_log.end() && !disabled_log[file]))){
			if(list_file.find(file) == list_file.end()){
				list_file[file] = std::unique_ptr<std::ofstream>(new std::ofstream);
				list_file[file]->open(log_foder+'/'+file + ".csv");
				list_var_idx.emplace(file,VarIdx());
				list_var_value.emplace(file,VarVal());
				list_var_name.emplace(file,VarName());
			}
			if(list_var_idx[file].find(varname) == list_var_idx[file].end()) {
				list_var_name[file].push_back(varname);
				list_var_value[file].push_back(std::unique_ptr<AnyBase>(new Any<K>(var)));
				list_var_idx[file][varname] = list_var_value[file].size()-1;
			}else{
				list_var_value[file][list_var_idx[file][varname]] = std::unique_ptr<AnyBase>(new Any<K>(var));
			}
		}
	}

	void write_line(std::string file) {
		if(is_enabled(file)) {
			VarName *names = &list_var_name[file];
			VarVal *values = &list_var_value[file];
			if (list_first_print.find(file) == list_first_print.end()) {
#ifdef DEBUG
				std::cout << "Logger "<< file <<": Print variable names: [ ";
#endif
				for (VarName::iterator it = names->begin() ; it != names->end();){
					*list_file[file] << *it;
#ifdef DEBUG
					std::cout << *it << " ";
#endif
					if (++it != names->end())
						*list_file[file] << ", ";
				}
				*list_file[file] << ";\n";
				list_first_print[file] = false;
#ifdef DEBUG
				std::cout << "]" << std::endl;
#endif
			}
#ifdef DEBUG
			std::cout << "Logger "<< file <<": Print values: [ ";
#endif
			for (VarVal::iterator it = values->begin(); it != values->end();){
				//std::stringstream buffer;
				//buffer << *it->second;
				//std::string aux( buffer.str().size(), '\0');
				//assert(buffer.str().size()==aux.size());
				//std::replace_copy( buffer.str().begin(), buffer.str().end(), aux.begin(), '4', ' ');

				*list_file[file] << **it;
#ifdef DEBUG
				std::cout << **it << " ";
#endif
				if (++it != values->end())
					*list_file[file] << ", ";
			}
#ifdef DEBUG
			std::cout << "]" << std::endl;
#endif
			*list_file[file] << ";\n";
		}
	}
};

extern LogManager logger;

#endif