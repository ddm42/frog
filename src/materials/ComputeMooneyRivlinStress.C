//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ComputeMooneyRivlinStress.h"

registerMooseObject("FROGApp", ComputeMooneyRivlinStress);

InputParameters
ComputeMooneyRivlinStress::validParams()
{
  InputParameters params = ComputeLagrangianStressPK2::validParams();

  params.addParam<MaterialPropertyName>("c1",
                                        "c1",
                                        "1st coefficient (C_10) for"
                                        " 2 parameter Mooney-Rivlin material");
  params.addParam<MaterialPropertyName>("c2",
                                        "c2",
                                        "2nd coefficient (C_01) for"
                                        " 2 parameter Mooney-Rivlin material");

  return params;
}

ComputeMooneyRivlinStress::ComputeMooneyRivlinStress(const InputParameters & parameters)
  : ComputeLagrangianStressPK2(parameters),
    _c1(getMaterialProperty<Real>(getParam<MaterialPropertyName>("c1"))),
    _c2(getMaterialProperty<Real>(getParam<MaterialPropertyName>("c2")))

{
}

void ComputeMooneyRivlinStress::computeQpPK2Stress()
{
  usingTensorIndices(i_, j_, k_, l_);

  // Large deformation = nonlinear strain
  if (_large_kinematics)
  {
    RankTwoTensor C = _F[_qp].transpose() * _F[_qp]; // Right Cauchy-Green deformation tensor
    RankTwoTensor Cinv = C.inverse();               
    double I1 = C.trace();                           // First invariant of C
    double I3 = C.det();                             // Third invariant of C

    double C1 = _c1[_qp]; // kPa
    double C2 = _c2[_qp]; // kPa
    double B = std::pow(10, 5) * std::max(C1,C2); // Beta
    double p0 = 2*C2-C1;

    RankTwoTensor S = 2 * (C1 * RankTwoTensor::Identity() + C2 * (I1 * RankTwoTensor::Identity() - C.transpose())) + 2 * (p0 + B * std::log(I3)) * Cinv;
    
    RankFourTensor C_tangent1 = 2 * C2 * (RankTwoTensor::Identity().times<i_, j_, k_, l_>(RankTwoTensor::Identity()) - RankTwoTensor::Identity().times<j_, k_, i_, l_>(RankTwoTensor::Identity())) - (2 * p0 + 2 * B * std::log(I3)) * Cinv.times<i_, k_, l_, j_>(Cinv) + 2 * B * Cinv.times<i_, j_, l_, k_>(Cinv);
    RankFourTensor C_tangent2 = RankTwoTensor::Identity().times<j_, l_, i_, k_>(_F[_qp].transpose()) + RankTwoTensor::Identity().times<i_, l_, k_, j_>(_F[_qp]);
    RankFourTensor C_tangent = C_tangent1*C_tangent2;

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