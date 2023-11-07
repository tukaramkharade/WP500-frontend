<!DOCTYPE html>
<html>
<head>
  <title>Add Child Node to Selected Tree Node</title>
  <style>
    ul.tree {
      list-style: none;
      padding-left: 1rem;
    }

   ul.tree > li {
  margin: 0.5rem 0;
  cursor: pointer;
}

.expandable::before {
  content: "▶";
  margin-right: 0.3rem;
  display: inline-block;
}

.expandable.collapsed::before {
  content: "▼";
}
  </style>
</head>
<body>
  <ul id="tree" class="tree">
    <li class="expandable" id="root">Root
      <ul class="tree">
        <li class="expandable" id="node1">Node 1
          <ul class="tree" id="childNodes1">
            <li id="newNode1">Leaf 1</li>
            <li id="newNode2">Leaf 2</li>
          </ul>
        </li>
        <li id="node3">Leaf 3</li>
      </ul>
    </li>
  </ul>

  <button id="addNodeButton">Add Child Node</button>
  <input type="text" id="newNodeName" placeholder="Enter child node name">

  <script>
    document.getElementById('addNodeButton').addEventListener('click', function() {
      const selectedNode = document.querySelector('.selected');
      const newNodeText = document.getElementById('newNodeName').value;

      if (selectedNode && newNodeText) {
        const ul = selectedNode.querySelector('ul');
        if (!ul) {
          // Create a new <ul> if it doesn't exist
          const newUl = document.createElement('ul');
          selectedNode.appendChild(newUl);
        }

        const li = document.createElement('li');
        li.textContent = newNodeText;
        ul.appendChild(li);
      }
    });

    const tree = document.getElementById('tree');
    tree.addEventListener('click', function(event) {
      if (event.target.tagName === 'LI') {
        // Remove the 'selected' class from all nodes
        const nodes = document.querySelectorAll('.selected');
        nodes.forEach(function(node) {
          node.classList.remove('selected');
        });

        // Add the 'selected' class to the clicked node
        event.target.classList.add('selected');
      }
    });
  </script>
</body>
</html>
