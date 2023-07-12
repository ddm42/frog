#
# Initial single block mechanics input
# https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step01.html
#

  [GlobalParams]
    displacements = 'disp_x disp_y'
  []
  
  [Mesh]
    [generated]
      type = GeneratedMeshGenerator
      dim = 2
      nx = 10
      ny = 10
      xmax = 1
      ymax = 1
    []
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
      boundary = left
      value = 0
    []
    [bottom_y]
      type = DirichletBC
      variable = disp_y
      boundary = left
      value = 0
    []
    [Pressure]
      [top]
        boundary = right
        function = -1
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