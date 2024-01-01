//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ComputeBladderStress.h"

registerMooseObject("FROGApp", ComputeBladderStress);

InputParameters
ComputeBladderStress::validParams()
{
  InputParameters params = ComputeLagrangianStressPK2::validParams();
  // W(E) = b1 * I_1^2 + b2 * I_2 + c * (exp(a1 * I_1^2 + a2 * I_2) - 1)
  params.addParam<MaterialPropertyName>("c",
                                        "c",
                                        "coefficient in vanBeek1997 bladder model");
  params.addParam<MaterialPropertyName>("a1",
                                        "a1",
                                        "coefficient in vanBeek1997 bladder model");
  params.addParam<MaterialPropertyName>("a2",
                                        "a2",
                                        "coefficient in vanBeek1997 bladder model");
  params.addParam<MaterialPropertyName>("b1",
                                        "b1",
                                        "coefficient in vanBeek1997 bladder model");
  params.addParam<MaterialPropertyName>("b2",
                                        "b2",
                                        "coefficient in vanBeek1997 bladder model");

  return params;
}

ComputeBladderStress::ComputeBladderStress(const InputParameters & parameters)
  : ComputeLagrangianStressPK2(parameters),
    _c(getMaterialProperty<Real>(getParam<MaterialPropertyName>("c"))),
    _a1(getMaterialProperty<Real>(getParam<MaterialPropertyName>("a1"))),
    _a2(getMaterialProperty<Real>(getParam<MaterialPropertyName>("a2"))),
    _b1(getMaterialProperty<Real>(getParam<MaterialPropertyName>("b1"))),
    _b2(getMaterialProperty<Real>(getParam<MaterialPropertyName>("b2")))
{
}

void ComputeBladderStress::computeQpPK2Stress()
{
  usingTensorIndices(i_, j_, k_, l_);

  // Large deformation = nonlinear strain
  if (_large_kinematics)
  {
    RankTwoTensor E = _E[_qp];
    double I1 = E.trace();
    double I2 = E.generalSecondInvariant();

    double c = _c[_qp]; // units of stress (e.g. kPa)
    double a1 = _a1[_qp]; // unitless
    double a2 = _a2[_qp]; // unitless
    double b1 = _b1[_qp]; // unitless
    double b2 = _b2[_qp]; // unitless

    RankTwoTensor S = 2 * b1 * I1 * RankTwoTensor::Identity() - b2 * (I1 * RankTwoTensor::Identity() - E.transpose()) + c * std::exp(a1 * std::pow(I1,2) - a2 * I2) * (2 * a1 * I1 * RankTwoTensor::Identity() - a2 * (I1 * RankTwoTensor::Identity() - E.transpose()));
    
    RankTwoTensor C_tangent1 = 2 * a1 * I1 * RankTwoTensor::Identity() - a2 * (I1 * RankTwoTensor::Identity() - E.transpose());

    RankFourTensor C_tangent = (2 * b1 - b2) * RankTwoTensor::Identity().times<i_, j_, k_, l_>(RankTwoTensor::Identity())
    + b2 * RankTwoTensor::Identity().times<j_, k_, i_, l_>(RankTwoTensor::Identity())
    + c * std::exp(a1 * std::pow(I1,2) - a2 * I2) 
    * ( (2 * a1 - a2) * RankTwoTensor::Identity().times<i_, j_, k_, l_>(RankTwoTensor::Identity()) 
    + a2 * RankTwoTensor::Identity().times<j_, k_, i_, l_>(RankTwoTensor::Identity()) 
    + (C_tangent1).times<i_, j_, k_, l_>(C_tangent1) );

    _S[_qp] = S;
    _C[_qp] = C_tangent;
  }
  // Small deformations = linear strain
  else
  {
    // Implementation for linear strain case
    // ******************FILLER*****************
    // Correct this if you need to use it.
    _C[_qp] = RankFourTensor::Identity();
    _S[_qp] = RankTwoTensor::Identity();
  }
}