[Mesh]
  file = /home/ddm42/projects/frog/mesh/t1.msh
  coord_type = RZ # symmetric as a sphere (problem becomes 1D technically)
[]

[Master]
  [all]
    strain = SMALL
    add_variables = true
    new_system = true
    formulation = TOTAL
    volumetric_locking_correction = true
    generate_output = 'cauchy_stress_xx cauchy_stress_yy cauchy_stress_zz cauchy_stress_xy cauchy_stress_xz cauchy_stress_yz strain_xx strain_yy strain_zz strain_xy strain_xz strain_yz'
  []
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.0e6
    poissons_ratio = 0.3
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