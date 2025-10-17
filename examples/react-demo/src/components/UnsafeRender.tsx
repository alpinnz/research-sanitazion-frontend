import React from 'react';

export const UnsafeRender: React.FC<{ html: string }> = ({ html }) => {
    return (
        <div
            data-testid="unsafe"
            style={{ border: '1px solid #f87171', padding: '8px', borderRadius: '8px', background: '#fee2e2' }}
            dangerouslySetInnerHTML={{ __html: html }}
        />
    );
};
