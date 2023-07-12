#
# Initial single block mechanics input
# https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step01.html
#

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  large_kinematics = true
[]

[Variables]
  [disp_x] 
    order = FIRST
  []
  [disp_y]
    order = FIRST
  []
  [disp_z]
    order = FIRST
  []
[]

[Mesh]
  [generated]
    type = GeneratedMeshGenerator
    #elem_type = HEX27
    dim = 3
    nx = 10
    ny = 10
    nz = 10
    xmax = 1
    ymax = 1
    zmax = 1
  []
[]

[Kernels]
  [sdx]
    type = TotalLagrangianStressDivergence
    variable = disp_x
    component = 0
  []
  [sdy]
    type = TotalLagrangianStressDivergence
    variable = disp_y
    component = 1
  []
  [sdz]
    type = TotalLagrangianStressDivergence
    variable = disp_z
    component = 2
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
      value = 0 # meters
    []
    [bottom_y]
      type = DirichletBC
      variable = disp_y
      boundary = left
      value = 0 # meters
    []
    [bottom_z]
      type = DirichletBC
      variable = disp_z
      boundary = left
      value = 0
    []
    [Pressure]
      [right]
        boundary = right
        function = -1*2.942 # kPa = 30 cm. H2O
      []
    []
  []
  
  [Materials] # StVenantKirchhoffStress Modelfrog/problems/hyperelastic_cube.i
    [elasticity]
      type = ComputeIsotropicElasticityTensor
      shear_modulus = 20.13 # kPa
      lambda = 986.58 # kPa
      # Equations relating shear E and v to Lame params:
      # https://encyclopediaofmath.org/wiki/Lam%C3%A9_constants#:~:text=The%20Lam%C3%A9%20constants%20are%20connected,is%20the%20modulus%20of%20shear.
      # 
      # Paper with E of bladder:
      # https://link.springer.com/content/pdf/10.1007/BF02457796.pdf?pdf=button 
      #
      # Paper claiming poisson ration is about 0.5 (don't trust it):
      # https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4285607/#:~:text=These%20studies%20treated%20bladder%20as,8%2C%2051%2C%2052%5D.
    []
    [stress]
      type = ComputeStVenantKirchhoffStress
    []
    [strain]
      type = ComputeLagrangianStrain
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
    solve_type = NEWTON
    #end_time = 5
    #dt = 1
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = 'lu mumps'
  []

  
  [Outputs]
    exodus = true
  []