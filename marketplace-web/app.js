// Marketplace Web Interface

// Sample data (in a real application, this would come from an API)
const assets = [
    {
        name: 'docker-best-practices',
        type: 'skill',
        category: 'devops',
        description: 'Complete guide for Docker and containers best practices in production',
        tags: ['docker', 'containers', 'devops'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'kubernetes-best-practices',
        type: 'skill',
        category: 'devops',
        description: 'Best practices for Kubernetes container orchestration and deployment',
        tags: ['kubernetes', 'containers', 'orchestration'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'rest-api-design',
        type: 'skill',
        category: 'backend',
        description: 'Best practices for REST API design and implementation',
        tags: ['rest', 'api', 'backend'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'react-patterns',
        type: 'skill',
        category: 'frontend',
        description: 'Best practices for React component patterns and architecture',
        tags: ['react', 'javascript', 'frontend'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'unit-testing',
        type: 'skill',
        category: 'testing',
        description: 'Best practices for unit testing and test-driven development',
        tags: ['testing', 'tdd', 'quality'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'owasp-top-10',
        type: 'skill',
        category: 'security',
        description: 'Best practices for addressing OWASP Top 10 security risks',
        tags: ['owasp', 'security', 'vulnerabilities'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'devops-engineer',
        type: 'agent',
        category: 'devops',
        description: 'DevOps Engineer specialized in infrastructure and CI/CD',
        tags: ['devops', 'infrastructure', 'ci-cd'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'backend-developer',
        type: 'agent',
        category: 'backend',
        description: 'Backend Developer specialized in APIs and distributed systems',
        tags: ['backend', 'api', 'database'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'frontend-developer',
        type: 'agent',
        category: 'frontend',
        description: 'Frontend Developer specialized in UI/UX and frontend technologies',
        tags: ['frontend', 'ui', 'ux'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'code-review-checklist',
        type: 'prompt',
        category: 'quality',
        description: 'Comprehensive code review checklist',
        tags: ['code-review', 'quality', 'checklist'],
        compatible: ['opencode', 'claude-code', 'cursor']
    },
    {
        name: 'skill-template',
        type: 'template',
        category: 'development',
        description: 'Template for creating new skills',
        tags: ['template', 'skill', 'development'],
        compatible: ['opencode', 'claude-code', 'cursor']
    }
];

// DOM Elements
const searchInput = document.getElementById('search-input');
const searchBtn = document.getElementById('search-btn');
const typeFilter = document.getElementById('type-filter');
const categoryFilter = document.getElementById('category-filter');
const compatibilityFilter = document.getElementById('compatibility-filter');
const resultsContainer = document.getElementById('results');
const totalSkills = document.getElementById('total-skills');
const totalAgents = document.getElementById('total-agents');
const totalPrompts = document.getElementById('total-prompts');
const totalTemplates = document.getElementById('total-templates');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    updateStats();
    renderAssets(assets);
});

// Event Listeners
searchBtn.addEventListener('click', filterAssets);
searchInput.addEventListener('keyup', (e) => {
    if (e.key === 'Enter') {
        filterAssets();
    }
});

typeFilter.addEventListener('change', filterAssets);
categoryFilter.addEventListener('change', filterAssets);
compatibilityFilter.addEventListener('change', filterAssets);

// Functions
function filterAssets() {
    const searchTerm = searchInput.value.toLowerCase();
    const type = typeFilter.value;
    const category = categoryFilter.value;
    const compatibility = compatibilityFilter.value;
    
    let filtered = assets;
    
    // Filter by search term
    if (searchTerm) {
        filtered = filtered.filter(asset => 
            asset.name.toLowerCase().includes(searchTerm) ||
            asset.description.toLowerCase().includes(searchTerm) ||
            asset.tags.some(tag => tag.toLowerCase().includes(searchTerm))
        );
    }
    
    // Filter by type
    if (type !== 'all') {
        filtered = filtered.filter(asset => asset.type === type);
    }
    
    // Filter by category
    if (category !== 'all') {
        filtered = filtered.filter(asset => asset.category === category);
    }
    
    // Filter by compatibility
    if (compatibility !== 'all') {
        filtered = filtered.filter(asset => asset.compatible.includes(compatibility));
    }
    
    renderAssets(filtered);
}

function renderAssets(assetsToRender) {
    resultsContainer.innerHTML = '';
    
    if (assetsToRender.length === 0) {
        resultsContainer.innerHTML = '<p>No assets found matching your criteria.</p>';
        return;
    }
    
    assetsToRender.forEach(asset => {
        const card = document.createElement('div');
        card.className = 'asset-card';
        card.innerHTML = `
            <span class="type-badge">${asset.type}</span>
            <h3>${asset.name}</h3>
            <p class="description">${asset.description}</p>
            <div class="tags">
                ${asset.tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
            </div>
            <button class="install-btn" onclick="installAsset('${asset.name}', '${asset.type}')">Install</button>
        `;
        resultsContainer.appendChild(card);
    });
}

function updateStats() {
    const stats = {
        skill: 0,
        agent: 0,
        prompt: 0,
        template: 0
    };
    
    assets.forEach(asset => {
        if (stats.hasOwnProperty(asset.type)) {
            stats[asset.type]++;
        }
    });
    
    totalSkills.textContent = stats.skill;
    totalAgents.textContent = stats.agent;
    totalPrompts.textContent = stats.prompt;
    totalTemplates.textContent = stats.template;
}

function installAsset(name, type) {
    alert(`Installing ${type}: ${name}\n\nIn a real application, this would run:\n./core/marketplace/install.sh ${type} ${name}`);
}