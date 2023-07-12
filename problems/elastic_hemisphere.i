#
# Initial single block mechanics input
# https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step01.html
#

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  file = /home/ddm42/projects/frog/mesh/hemisphere.msh
[]

[Modules/TensorMechanics/Master]
  [all]
    strain = small
    add_variables = true
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
      boundary = 67
      value = 0 # meters
    []
    [bottom_y]
      type = DirichletBC
      variable = disp_y
      boundary = 67
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
        function = 1 
      []
    []
  []
  
  [Materials] # Constitutive equations
    [elasticity] # Material property specifications
      type = ComputeIsotropicElasticityTensor
      youngs_modulus = 10
      poissons_ratio = 0
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
    type = Steady
    solve_type = LINEAR
    #end_time = 5
    #dt = 1
  []

  
  [Outputs]
    exodus = true
  []
