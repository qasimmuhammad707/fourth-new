import React from 'react';

const Footer: React.FC = () => {
    return (
        <footer>
            <div className="footer-content">
                <p>&copy; {new Date().getFullYear()} Qasim Jutt. All rights reserved.</p>
                <div className="social-links">
                    <a href="https://github.com/qasimjutt" target="_blank" rel="noopener noreferrer">GitHub</a>
                    <a href="https://linkedin.com/in/qasimjutt" target="_blank" rel="noopener noreferrer">LinkedIn</a>
                    <a href="https://twitter.com/qasimjutt" target="_blank" rel="noopener noreferrer">Twitter</a>
                </div>
            </div>
        </footer>
    );
};

export default Footer;