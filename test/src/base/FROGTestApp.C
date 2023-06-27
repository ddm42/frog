//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "FROGTestApp.h"
#include "FROGApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
FROGTestApp::validParams()
{
  InputParameters params = FROGApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

FROGTestApp::FROGTestApp(InputParameters parameters) : MooseApp(parameters)
{
  FROGTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

FROGTestApp::~FROGTestApp() {}

void
FROGTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  FROGApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"FROGTestApp"});
    Registry::registerActionsTo(af, {"FROGTestApp"});
  }
}

void
FROGTestApp::registerApps()
{
  registerApp(FROGApp);
  registerApp(FROGTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
FROGTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  FROGTestApp::registerAll(f, af, s);
}
extern "C" void
FROGTestApp__registerApps()
{
  FROGTestApp::registerApps();
}
