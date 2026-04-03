import React from 'react';
import ProjectCard from '../components/ProjectCard';

const projectsData = [
  {
    title: 'Project One',
    description: 'Description of Project One',
    link: 'https://link-to-project-one.com',
  },
  {
    title: 'Project Two',
    description: 'Description of Project Two',
    link: 'https://link-to-project-two.com',
  },
  {
    title: 'Project Three',
    description: 'Description of Project Three',
    link: 'https://link-to-project-three.com',
  },
];

const Projects = () => {
  return (
    <div>
      <h1>My Projects</h1>
      <div className="projects-list">
        {projectsData.map((project, index) => (
          <ProjectCard
            key={index}
            title={project.title}
            description={project.description}
            link={project.link}
          />
        ))}
      </div>
    </div>
  );
};

export default Projects;