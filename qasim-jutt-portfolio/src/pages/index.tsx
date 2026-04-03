import React from 'react';
import Header from '../components/Header';
import Footer from '../components/Footer';
import ProjectCard from '../components/ProjectCard';

const IndexPage = () => {
  const projects = [
    {
      title: 'Project One',
      description: 'Description of project one.',
      link: '#',
    },
    {
      title: 'Project Two',
      description: 'Description of project two.',
      link: '#',
    },
    {
      title: 'Project Three',
      description: 'Description of project three.',
      link: '#',
    },
  ];

  return (
    <div>
      <Header />
      <main>
        <h1>Welcome to Qasim Jutt's Portfolio</h1>
        <section>
          <h2>Projects</h2>
          <div>
            {projects.map((project, index) => (
              <ProjectCard key={index} {...project} />
            ))}
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default IndexPage;