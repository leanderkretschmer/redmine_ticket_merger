// Ticket Merger Plugin JavaScript

document.addEventListener('DOMContentLoaded', function() {
  // Kontextmenü für Issues erweitern
  extendIssueContextMenu();
});

function extendIssueContextMenu() {
  // Warten bis das Kontextmenü geladen ist
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if (mutation.type === 'childList') {
        mutation.addedNodes.forEach(function(node) {
          if (node.nodeType === Node.ELEMENT_NODE) {
            const contextMenu = node.querySelector('.contextual');
            if (contextMenu) {
              addMergeOption(contextMenu);
            }
          }
        });
      }
    });
  });
  
  observer.observe(document.body, {
    childList: true,
    subtree: true
  });
  
  // Auch beim ersten Laden prüfen
  const contextMenu = document.querySelector('.contextual');
  if (contextMenu) {
    addMergeOption(contextMenu);
  }
}

function addMergeOption(contextMenu) {
  // Prüfen ob Merge-Option bereits hinzugefügt wurde
  if (contextMenu.querySelector('.merge-issue-option')) {
    return;
  }
  
  // Issue-ID aus der URL extrahieren
  const issueId = getIssueIdFromUrl();
  if (!issueId) {
    return;
  }
  
  // Merge-Option hinzufügen
  const mergeOption = document.createElement('li');
  mergeOption.className = 'merge-issue-option';
  
  const mergeLink = document.createElement('a');
  mergeLink.href = `/issues/${issueId}/merge_form`;
  mergeLink.className = 'icon icon-merge';
  mergeLink.textContent = 'Ticket zusammenführen';
  
  mergeOption.appendChild(mergeLink);
  
  // Nach der "Bearbeiten" Option einfügen
  const editOption = contextMenu.querySelector('a.icon-edit');
  if (editOption) {
    editOption.parentNode.parentNode.insertBefore(mergeOption, editOption.parentNode.nextSibling);
  } else {
    contextMenu.appendChild(mergeOption);
  }
}

function getIssueIdFromUrl() {
  const match = window.location.pathname.match(/\/issues\/(\d+)/);
  return match ? match[1] : null;
}
