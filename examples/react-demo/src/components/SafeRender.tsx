import React from 'react';
import { sanitizeHtml } from '../lib/sanitize';

export const SafeRender: React.FC<{ html: string }> = ({ html }) => {
    const clean = sanitizeHtml(html);
    return (
        <div
            data-testid="safe"
            style={{ border: '1px solid #4ade80', padding: '8px', borderRadius: '8px', background: '#dcfce7' }}
            dangerouslySetInnerHTML={{ __html: clean }}
        />
    );
};
