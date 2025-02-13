import os
from dbterd.api import DbtErd

erd = DbtErd(artifacts_dir="target/").get_erd()
print("erd (dbml):", erd)

erd = DbtErd(target="mermaid", artifacts_dir="target/").get_erd()
print("erd (mermaid):", erd)