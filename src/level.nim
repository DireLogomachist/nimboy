type
  EnemySpawnType* = enum
    DiverSpawn, ExploderSpawn, GridBombSpawn
  
  SpawnEvent* = object
    triggerTime*: float      # Seconds into level
    enemyType*: EnemySpawnType
    x*, y*: float
    targetX*, targetY*: float = 0.0f  # For Exploder

  Level* = object
    name*: string
    spawns*: seq[SpawnEvent]

# Level definitions
const Level1*: seq[SpawnEvent] = @[
  SpawnEvent(triggerTime: 0.5, enemyType: DiverSpawn, x: 78, y: 150),
  SpawnEvent(triggerTime: 2.0, enemyType: ExploderSpawn, x: 150, y: 80, targetX: 256, targetY: 300),
  SpawnEvent(triggerTime: 3.5, enemyType: DiverSpawn, x: 300, y: 50),
  SpawnEvent(triggerTime: 5.0, enemyType: ExploderSpawn, x: 200, y: 100, targetX: 256, targetY: 350),
]
