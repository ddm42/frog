[Mesh]
  file = /home/ddm42/projects/frog/mesh/t1.msh
  coord_type = RSPHERICAL # symmetric as a sphere (problem becomes 1D technically)
[]

[Variables]
  [./disp_r]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_theta]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_phi]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./stress_x]
    type = StressDivergenceRSphericalTensors
    variable = disp_r
    component = 0
  [../]
  [./stress_y]
    type = StressDivergenceRSphericalTensors
    variable = disp_theta
    component = 1
  [../]
  [./stress_z]
    type = StressDivergenceRSphericalTensors
    variable = disp_phi
    component = 2
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.0e6
    poissons_ratio = 0.5 # according to doi: 10.1364/BOE.5.004313
    temperature = 293.0
    thermal_expansion_coeff = 1.0e-5
  [../]
  [./mooney_rivlin]
    type = MooneyRivlinMaterial
    c1 = 0.5
    c2 = 0.5
    uo = 2
  [../]
[]

[BCs] # placing no BC on outer surface leaves it free to move (pressure = 0)
  [./internal_pressure]
    type = Pressure
    variable = disp_r
    boundary = 1  # replace with the boundary id for the external surface
    function = 0.1
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
[]

[Outputs]
  exodus = true
[]