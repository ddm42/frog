#pragma once

#include "ComputeLagrangianStressPK2.h"

/// Hyperelastic Bladder model from vanBeek1997
///
///  Model follows from W(E) = b1 * I_1^2 + b2 * I_2 + c * (exp(a1 * I_1^2 + a2 * I_2) - 1)
///
///  I_1 = I_1(E), I_2 = I_2(E), I_3 = I_3(E)
///
///  Parameter definitions from ComputeLagrangianStressPK2:
///  _E : Green-Lagrange strain
///  _S : 2nd PK stress
///  _C : 2nd PK tangent (dS/dE)
///  https://mooseframework.inl.gov/modules/tensor_mechanics/NewMaterialSystem.html
///
///  Must override the computeQpPK2Stress()

class ComputeBladderStress : public ComputeLagrangianStressPK2
{
public:
  static InputParameters validParams();
  ComputeBladderStress(const InputParameters & parameters);

protected:
  /// Actual stress/Jacobian update
  virtual void computeQpPK2Stress();

protected:
  const MaterialProperty<Real> & _c; // units of stress (e.g. kPa)
  const MaterialProperty<Real> & _a1; // unitless
  const MaterialProperty<Real> & _a2; // unitless
  const MaterialProperty<Real> & _b1; // unitless
  const MaterialProperty<Real> & _b2; // unitless
};
