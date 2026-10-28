import * as React from 'react';
import { SidebarProvider } from '@/components/ui/sidebar';
import type { AppVariant } from '@/types';

type Props = React.ComponentProps<'div'> & {
    variant?: AppVariant;
};

export function AppShell({ variant = 'sidebar', children, ...props }: Props) {
    if (variant === 'sidebar') {
        return (
            <SidebarProvider>
                <div
                    className="flex h-svh w-full overflow-hidden"
                    {...props}
                >
                    {children}
                </div>
            </SidebarProvider>
        );
    }

    return (
        <div className="flex min-h-svh w-full flex-col" {...props}>
            {children}
        </div>
    );
}