#
# Initial single block mechanics input
# https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step01.html
#

[GlobalParams]
    displacements = 'disp_x disp_y'
    large_kinematics = true
  []
  
  [Variables]
    [disp_x]
    []
    [disp_y]
    []
  []
  
  [AuxVariables]
    [pressure]
      order = CONSTANT
      family = MONOMIAL
    []
  
  []
  
  [Mesh]
    [mesh]
      type = ConcentricCircleMeshGenerator
      has_outer_square = no
      num_sectors = 100
      radii = '0.027 0.03'
      rings = '1 3'
      preserve_volumes = false
    []
    [ss]
      type = SideSetsBetweenSubdomainsGenerator
      input = mesh
      new_boundary = push
      primary_block = 2
      paired_block = 1
    []
  
    [delete]
      type = BlockDeletionGenerator
      input = ss
      block = 1
    []
    [ns]
    type = ExtraNodesetGenerator
    input = delete
    new_boundary = hold
    nodes = 0
    []
  
  []
  
  [Modules/TensorMechanics/Master]
    [all]
      strain = FINITE
      new_system = true
      add_variables = true
      formulation = UPDATED
    []
  []
  
  # Added boundary/loading conditions
  # https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step02.html
  #
  [BCs]
    [bottom_x]
      type = DirichletBC
      variable = disp_x
      boundary = hold
      value = 0 # meters
    []
    [bottom_y]
      type = DirichletBC
      variable = disp_y
      boundary = hold
      value = 0 # meters
    []
  
    [Pressure]
      [right]
        boundary = push
        function = '4.3*t' # 14.5 kPa = 148.1 cm. H2O
        use_automatic_differentiation = true
      []
    []
  []
  
  # [AuxKernels]
  #   [pressure]
  #     type = FunctionAux
  #     variable = pressure
  #     function = '4.3e4*t'
  #     boundary = 65
  #     execute_on = TIMESTEP_END
  #   []
  # []
  
  [Materials] # StVenantKirchhoffStress Modelfrog/problems/hyperelastic_cube.i
    [stress]
      type = ComputeNeoHookeanStress
      mu = 3.36 # kPa
      lambda = 164.4 # kPa
      use_displaced_mesh = true
      # Equations relating shear E and v to Lame params:
      # https://encyclopediaofmath.org/wiki/Lam%C3%A9_constants#:~:text=The%20Lam%C3%A9%20constants%20are%20connected,is%20the%20modulus%20of%20shear.
      #
      # Paper with E of bladder:
      # https://link.springer.com/content/pdf/10.1007/BF02457796.pdf?pdf=button
      #
      # Paper claiming poisson ratio is about 0.5 (don't trust it):
      # https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4285607/#:~:text=These%20studies%20treated%20bladder%20as,8%2C%2051%2C%2052%5D.
    []
  []
  
  # # consider all off-diagonal Jacobians for preconditioning
  [Preconditioning]
    [SMP]
      type = SMP
      full = true
    []
  []
  [Functions]
    [timestepper]
      type = PiecewiseConstant
      x = '0 0.05 0.075 1'
      y = '0.001 0.0001 0.00005'
      direction = LEFT
    []
  []
  
  [Executioner]
    type = Transient
    solve_type = NEWTON
    end_time = 1 # <--- failing at .1655
    # dt = .001
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = 'lu superlu_dist'
  
    nl_abs_tol = 1e-9
    line_search = none
    [TimeStepper]
      type = FunctionDT
      function = timestepper
    []
  []
  
  [Outputs]
    exodus = true
    print_linear_residuals = false
  []
  