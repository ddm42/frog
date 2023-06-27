#include "FROGApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
FROGApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

FROGApp::FROGApp(InputParameters parameters) : MooseApp(parameters)
{
  FROGApp::registerAll(_factory, _action_factory, _syntax);
}

FROGApp::~FROGApp() {}

void 
FROGApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<FROGApp>(f, af, s);
  Registry::registerObjectsTo(f, {"FROGApp"});
  Registry::registerActionsTo(af, {"FROGApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
FROGApp::registerApps()
{
  registerApp(FROGApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
FROGApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  FROGApp::registerAll(f, af, s);
}
extern "C" void
FROGApp__registerApps()
{
  FROGApp::registerApps();
}
