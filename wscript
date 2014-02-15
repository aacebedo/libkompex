# Build file for kompex library
import os
from waflib import Logs

APPNAME = 'kompex'
VERSION = '0.1.0'

top = '.'
out = 'build'

def addLibraryPath(libName,path,libPaths):
  if path != None :
    libPaths.append(os.path.join(path,'lib'))
    Logs.pprint('WHITE','{0: <40}'.format('Library \''+libName+'\' will be searched in '),sep=': ')
    Logs.pprint('GREEN',path)

def initializeConfigurations(conf):
  env = conf.env
  conf.setenv('debug',env)
  conf.env.CXXFLAGS = ['-g']
    
  conf.setenv('release',env)
  conf.env.CXXFLAGS = ['-O3']

def init(ctx):
  global out
  if ctx.options.mode != 'debug' and ctx.options.mode != 'release' :
    ctx.fatal("Mode is invalid, shall be release or debug")
    
  out = os.path.join('build',ctx.options.mode)

def options(opt):
  opt.load('compiler_cxx')
  opt.add_option('--with-sqlite3', action='store', default=None, help='Path to SQLite 3 library')
  opt.add_option('--mode', action='store', default="debug", help='target: [debug|release] ')  
  
def configure(conf):
  conf.load('compiler_cxx')
  
  conf.env.LIBPATH = []

  addLibraryPath('sqlite3',conf.options.with_sqlite3, conf.env.LIBPATH)
  conf.check_cxx(lib='sqlite3', use_lib='SQLITE3')
  conf.check(header_name='sqlite3.h')
  
  conf.env.MODE = conf.options.mode

  initializeConfigurations(conf)  

def build(bld): 
  
  bld.env = bld.all_envs[bld.env.MODE]
  
  srcdir = bld.path.find_dir('src')
    
  bld.shlib(
    source=srcdir.ant_glob('**/*.cpp'), 
    target='kompex',
    includes = [srcdir],
    cxxflags = bld.env.CXXFLAGS,
    vnum=VERSION
  )
  
  bld.install_files('${PREFIX}/include',
                  srcdir.ant_glob('**/*.h'),
                   cwd=srcdir)