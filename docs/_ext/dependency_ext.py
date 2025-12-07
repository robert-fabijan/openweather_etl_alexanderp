from sphinx.util.docutils import SphinxDirective
from sphinx.environment.collectors import EnvironmentCollector
from docutils import nodes
from collections import defaultdict
from typing import Any, Dict, Set
from sphinxcontrib.mermaid import mermaid
from docutils.parsers.rst.directives import unchanged

# 1. HELPER
def get_dependency_graph(env) -> defaultdict[str, list[str]]:
    key = 'dep_graph_data' 
    if not hasattr(env, key):
        setattr(env, key, {'graph': defaultdict(list)})
    return getattr(env, key)['graph']

# 2. COLLECTOR
class DepGraphCollector(EnvironmentCollector):
    def clear_doc(self, app, env, docname: str) -> None:
        graph = get_dependency_graph(env)
        keys_to_remove = [k for k in graph.keys() if k.startswith(f"{docname}:")]
        for k in keys_to_remove:
            del graph[k]

    def merge_other(self, app, env, docnames: Set[str], other: Any) -> None:
        current_graph = get_dependency_graph(env)
        other_graph = get_dependency_graph(other)
        for key, value in other_graph.items():
            current_graph[key].extend(value)
    
    # --- CRITICAL FIX 1: 'docname' REMOVED from signature ---
    # Sphinx calls this with only (app, doctree)
    def process_doc(self, app, doctree) -> None:
        pass
    
    def get_updated_docnames(self, app, env) -> list[str]:
        return []

# 3. DIRECTIVE
class DependencyDirective(SphinxDirective):
    required_arguments = 1
    optional_arguments = 0
    # --- CRITICAL FIX 2: This must be True to handle parsing correctly ---
    final_argument_whitespace = True
    has_content = True

    def run(self):
        source_name = self.arguments[0]
        dependencies = [line.strip() for line in self.content if line.strip()]

        env = self.env
        graph = get_dependency_graph(env)
        key = f"{env.docname}:{source_name}"
        graph[key].extend(dependencies)

        return []

# 4. OUTPUT HANDLER (Mermaid)
def process_dependency_nodes(app, doctree, docname):
    graph = get_dependency_graph(app.env)
    
    # Check if there are any dependencies for the current document
    has_relevant_nodes = False
    for source_key in graph.keys():
        if source_key.startswith(f"{docname}:"):
            has_relevant_nodes = True
            break
            
    if not has_relevant_nodes:
        return

    # Generate Mermaid Graph
    mermaid_code = ["graph LR"]
    
    for source_key, dependencies in graph.items():
        if source_key.startswith(f"{docname}:"):
            # Clean names for Mermaid IDs
            src_clean = source_key.split(':')[-1]
            src_id = src_clean.replace('.', '_').replace(':', '_')
            
            for dep in dependencies:
                dep_clean = dep
                dep_id = dep.replace('.', '_').replace(':', '_')
                mermaid_code.append(f"    {src_id}[{src_clean}] --> {dep_id}[{dep_clean}]")

    if len(mermaid_code) > 1:
        graph_syntax = "\n".join(mermaid_code)
        
        # Create a proper container section
        section = nodes.section()
        section['ids'] = ['dependency-graph']
        
        # Add title
        title = nodes.title(text='Dependency Graph')
        section += title
        
        # Create mermaid node properly
        mermaid_node = mermaid()
        mermaid_node['code'] = graph_syntax
        mermaid_node['options'] = {}
        section += mermaid_node
        
        doctree.append(section)

# 5. SETUP
def setup(app):
    app.add_env_collector(DepGraphCollector)
    app.add_directive('dependency', DependencyDirective)
    app.connect('doctree-resolved', process_dependency_nodes)

    return {
        'version': '0.1.0',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }