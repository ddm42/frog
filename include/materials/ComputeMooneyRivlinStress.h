#pragma once

#include "ComputeLagrangianStressPK2.h"

/// Inompressible Mooney-Rivlin hyperelasticity (and initially isotropic)
///
///  Model follows from W = lambda / 2 * (ln J)^2 - mu * ln J + 1/2 * mu *
///  (tr(C)- I)
///
///  Model follows from W = c_1*(I_1-3)+c_2*(I_2-3)
///
///  Incompressibility means I_3 = J = det(F) = 1.
///  In order to enforce this, the constraint is expressed: ln(I_3) = 0
///  The Modified strain energy function and the constitutive equation are:
///
///  W~ = W + p_0*ln(I_3) + B/2*(ln(I_3))^2
///
///  S = 2*d(W~)/dC , where C is the right Cauchy-Green Strain tensor
///
///  with C = F^(T)F, J = det(F) and S = PK2 stress tensor
///       ^ Isn't this Green-Lagrange Strain??? Yes it is
///
///  Parameter definitions from ComputeLagrangianStressPK2:
///  _E : Green-Lagrange strain
///  _S : 2nd PK stress
///  _C : 2nd PK tangent (dS/dF)
///  https://mooseframework.inl.gov/modules/tensor_mechanics/NewMaterialSystem.html
///
///  Must override the computeQpPK2Stress()

class ComputeMooneyRivlinStress : public ComputeLagrangianStressPK2
{
public:
  static InputParameters validParams();
  ComputeMooneyRivlinStress(const InputParameters & parameters);

protected:
  /// Actual stress/Jacobian update
  virtual void computeQpPK2Stress();

protected:
  const MaterialProperty<Real> & _c1;
  const MaterialProperty<Real> & _c2;
};
