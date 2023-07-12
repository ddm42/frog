#
# Initial single block mechanics input
# https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step01.html
#

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  file = /home/ddm42/projects/frog/mesh/sphericalOctant.msh
[]

[Modules/TensorMechanics/Master]
  [all]
    strain = small
    add_variables = true
  []
[]

[AuxVariables]
  [pressure]
    order = CONSTANT
    family = MONOMIAL
  []
[]
#
# Added boundary/loading conditions
# https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step02.html
#
[BCs]
  [bottom_x]
    type = DirichletBC
    variable = disp_x
    boundary = 75
    value = 0 # meters
  []
  [bottom_y]
    type = DirichletBC
    variable = disp_y
    boundary = 74
    value = 0 # meters
  []
  [bottom_z]
    type = DirichletBC
    variable = disp_z
    boundary = 67
    value = 0
  []
  [Pressure]
    [right]
      boundary = 65
      function = 4.3*t # 14.5 kPa = 148.1 cm. H2O
    []
  []
[]

[AuxKernels]
  [pressure]
    type = FunctionAux
    variable = pressure
    function = '4.3*t'
    boundary = 65
    execute_on = TIMESTEP_END
  []
[]

[Materials] # Constitutive equations
  [elasticity] # Material property specifications
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 10
    poissons_ratio = .49
  []
  [stress] # Stress-Strain relationship equation
    type = ComputeLinearElasticStress
  []
[]

# # consider all off-diagonal Jacobians for preconditioning
# [Preconditioning]
#   [SMP]
#     type = SMP
#     full = true
#   []
# []

[Executioner]
  type = Transient
  solve_type = LINEAR
  end_time = 1
  dt = .1
[]


[Outputs]
  exodus = true
[]