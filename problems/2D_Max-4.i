[GlobalParams]
  displacements = 'disp_x disp_y'
  large_kinematics = true
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
    num_sectors = 300
    radii = '0.027 0.03'
    rings = '1 1'
    preserve_volumes = true
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
      function = '4.3*.001*t' # 14.5 kPa = 148.1 cm. H2O
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
    mu = .00336 # kPa
    lambda = .1644 # kPa
    use_displaced_mesh = true
  []
[]

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
  dt = .005
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'

  nl_abs_tol = 1e-9
  line_search = none
  # [TimeStepper]
  #   type = FunctionDT
  #   function = timestepper
  # []

  [Adaptivity]
    interval = 1
    refine_fraction = 1
    coarsen_fraction = 0
    max_h_level = 3
    # start_time = .01
  []

[]

[Outputs]
  exodus = true
  print_linear_residuals = false
[]
