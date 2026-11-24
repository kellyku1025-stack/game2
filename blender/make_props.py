"""Build original low-poly lantern, star coins, and lesson key props."""
import bpy, math
from pathlib import Path
from mathutils import Vector

bpy.ops.object.select_all(action="SELECT"); bpy.ops.object.delete(use_global=False)

def mat(name, color, metallic=0.0, rough=0.4):
    m=bpy.data.materials.new(name); m.diffuse_color=(*color,1); m.use_nodes=True
    p=m.node_tree.nodes.get("Principled BSDF"); p.inputs["Base Color"].default_value=(*color,1); p.inputs["Metallic"].default_value=metallic; p.inputs["Roughness"].default_value=rough
    return m
bronze=mat("Weathered bronze",(0.17,0.115,0.07),0.72); gold=mat("Star coin gold",(0.93,0.61,0.19),0.68,0.25); amber=mat("Lantern amber",(1.0,0.4,0.08),0.12,0.22)

def cyl(name,radius,depth,loc,material,vertices=12):
    bpy.ops.mesh.primitive_cylinder_add(vertices=vertices,radius=radius,depth=depth,location=loc)
    o=bpy.context.object; o.name=name; o.data.materials.append(material)
    b=o.modifiers.new("Worn edge bevel","BEVEL"); b.width=0.025; b.segments=2; o.modifiers.new("Weighted normals","WEIGHTED_NORMAL")
    return o

cyl("Lantern foot",0.46,0.12,(0,0,0.12),bronze); cyl("Glowing amber chamber",0.30,0.72,(0,0,0.54),amber,8); cyl("Lantern crown",0.43,0.12,(0,0,0.95),bronze)
for i in range(4):
    a=i*math.pi/2
    bpy.ops.mesh.primitive_cylinder_add(vertices=6,radius=0.035,depth=0.74,location=(0.33*math.cos(a),0.33*math.sin(a),0.54))
    bpy.context.object.name="Lantern cage rib"; bpy.context.object.data.materials.append(bronze)
for i in range(5):
    o=cyl("Star coin %02d"%(i+1),0.22,0.055,(1.1+i*0.5,0,0.1),gold,10); o.rotation_euler[0]=math.pi/2

bpy.ops.mesh.primitive_torus_add(major_radius=0.22,minor_radius=0.06,major_segments=12,minor_segments=6,location=(-1.25,0,0.2),rotation=(math.pi/2,0,0))
bpy.context.object.name="Key ring"; bpy.context.object.data.materials.append(gold)
def cube(name,loc,scale):
    bpy.ops.mesh.primitive_cube_add(size=1,location=loc); o=bpy.context.object; o.name=name; o.dimensions=scale; bpy.ops.object.transform_apply(location=False,rotation=False,scale=True); o.data.materials.append(gold)
    b=o.modifiers.new("Soft edge","BEVEL"); b.width=0.025; b.segments=2; o.modifiers.new("Weighted normals","WEIGHTED_NORMAL")
cube("Key shaft",(-0.82,0,0.2),(0.64,0.1,0.1)); cube("Key tooth A",(-0.59,0,0.14),(0.09,0.1,0.19)); cube("Key tooth B",(-0.43,0,0.14),(0.09,0.1,0.16))

project_assets = Path(r"C:\Godot\assets")
project_assets.mkdir(parents=True, exist_ok=True)
bpy.ops.wm.save_as_mainfile(filepath=r"C:\blender\little_dream_props.blend")
bpy.ops.export_scene.gltf(filepath=str(project_assets / "little_dream_props.glb"),export_format="GLB")
